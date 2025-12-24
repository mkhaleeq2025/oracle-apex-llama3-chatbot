-- =========================================================
-- File: ai_business_knowledge.sql
-- Purpose:
-- This view provides structured business context stored
-- in Oracle Database, which is supplied to LLaMA 3 at runtime
-- to improve chatbot responses in Oracle APEX.
--
-- Note:
-- The LLaMA 3 model is NOT trained here.
-- This data is used as contextual grounding (prompt context).
-- =========================================================

CREATE OR REPLACE FORCE EDITIONABLE VIEW AI_BUSINESS_KNOWLEDGE (
    DOMAIN,
    DESCRIPTION
) AS
SELECT 'SALES' AS domain,
       'Invoices are stored in CRM_SALE_INVOICE. INVOICE_DATE is the creation date.' AS description
FROM dual
UNION ALL
SELECT 'SALES',
       'Invoice lines are in CRM_SALE_INVOICE_DETAIL linked by SALE_INVOICE_FK.'
FROM dual
UNION ALL
SELECT 'CRM',
       'Deals are stored in CRM_DEALS. Status column shows OPEN or CLOSED.'
FROM dual
UNION ALL
SELECT 'CRM',
       'Leads are stored in CRM_LEADS. Created date is CREATED_ON.'
FROM dual;
