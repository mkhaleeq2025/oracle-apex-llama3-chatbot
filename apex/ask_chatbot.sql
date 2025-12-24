-- =========================================================
-- File: ask_chatbot_ai.sql
-- Purpose:
-- Oracle APEX PL/SQL function to call LLaMA 3 hosted on
-- an OCI Ubuntu VM via Ollama REST API.
--
-- The function supports:
-- 1. General chatbot responses
-- 2. SQL generation mode using business context from
--    Oracle Database (AI_BUSINESS_KNOWLEDGE view)
--
-- Note:
-- The AI model is NOT trained here.
-- Business data is injected as runtime prompt context.
-- =========================================================

CREATE OR REPLACE FUNCTION ask_chatbot_ai (
    p_prompt IN CLOB,
    p_type   IN VARCHAR2 DEFAULT 'GENERAL'
) RETURN CLOB
IS
    l_response CLOB;
    l_output   CLOB := '';
    l_line     VARCHAR2(32767);
    l_pos      INTEGER := 1;
    l_end      INTEGER;
    l_token    VARCHAR2(32767);
    l_prompt   CLOB;
BEGIN

    -- =====================================================
    -- Build AI Prompt
    -- =====================================================
    IF UPPER(p_type) = 'GENERAL' THEN
        l_prompt := p_prompt;

    ELSE
        l_prompt :=
            'You are an Oracle SQL expert.' || chr(10) ||
            'Rules:' || chr(10) ||
            '- Output ONLY Oracle SELECT statements' || chr(10) ||
            '- No explanations' || chr(10) ||
            '- No DML or DDL' || chr(10) ||
            'Business Knowledge:' || chr(10);

        FOR r IN (
            SELECT description
            FROM AI_BUSINESS_KNOWLEDGE
        ) LOOP
            l_prompt := l_prompt || '- ' || r.description || chr(10);
        END LOOP;

        l_prompt := l_prompt ||
            chr(10) || 'User Question: ' || p_prompt;
    END IF;

    -- =====================================================
    -- Call Ollama REST API (LLaMA 3)
    -- =====================================================
    l_response := apex_web_service.make_rest_request(
        p_url         => 'http://<OCI_VM_IP>:11435/api/generate',
        p_http_method => 'POST',
        p_body        => '{"model":"llama3","prompt":' ||
                          apex_json.stringify(l_prompt) || '}'
    );

    -- =====================================================
    -- Parse streaming JSON response (one JSON per line)
    -- =====================================================
    LOOP
        l_end := instr(l_response, chr(10), l_pos);
        EXIT WHEN l_end = 0;

        l_line := substr(l_response, l_pos, l_end - l_pos);

        l_token := regexp_substr(
            l_line,
            '"response"\s*:\s*"([^"]*)"',
            1, 1, NULL, 1
        );

        IF l_token IS NOT NULL THEN
            l_output := l_output || l_token;
        END IF;

        l_pos := l_end + 1;
    END LOOP;

    l_output := replace(l_output, '\n', chr(10));
    RETURN l_output;

END;
/
