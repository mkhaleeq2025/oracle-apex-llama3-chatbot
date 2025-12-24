# Oracle APEX AI Chatbot using LLaMA 3 (Ollama) on OCI
# oracle-apex-llama3-chatbot
Oracle APEX chatbot integrated with LLaMA 3 using Ollama on OCI Ubuntu VM


## Overview
This project demonstrates how to build an AI-powered chatbot using **Oracle APEX** integrated with a **LLaMA 3** large language model hosted on an **Oracle Cloud Infrastructure (OCI) Ubuntu compute instance** using **Ollama**.

The solution showcases how Oracle APEX and Oracle Database can be used as an enterprise AI gateway, where business knowledge remains securely stored in the database and is injected into AI prompts at runtime.


---

## Architecture
The architecture follows a clean and secure integration pattern:

- Oracle APEX handles user interaction and business logic
- Oracle Database stores structured business knowledge
- OCI Ubuntu VM hosts Ollama and the LLaMA 3 model
- Communication occurs via REST API

Oracle APEX
|
| (PL/SQL + REST)
v
OCI Ubuntu VM (Ollama)
|
v
LLaMA 3 Model


---

## Technologies Used
- Oracle APEX
- Oracle Database
- Oracle Cloud Infrastructure (OCI)
- OCI Compute (Ubuntu Linux)
- Ollama
- LLaMA 3
- PL/SQL
- REST APIs

---

## Project Structure
oracle-apex-llama3-chatbot/
├── README.md
├── apex/
│ ├── ai_business_knowledge.sql
│ ├── ask_oryx_ai.sql
│ └── README.md
├── ollama/
│ ├── install_ollama.sh
│ ├── test_llama3_api.sh
│ └── README.md
├── screenshots/


---

## Business Knowledge Context (Oracle Database)

Enterprise business knowledge is stored in the Oracle Database using a dedicated view:

**AI_BUSINESS_KNOWLEDGE**

This view contains structured descriptions of CRM and Sales data models and is used to provide contextual grounding for AI responses.

### Purpose
- Keep business knowledge inside Oracle Database
- Improve AI response accuracy without model retraining
- Allow easy updates to knowledge without code changes

> The AI model is **not trained or fine-tuned** using this data.  
> The data is injected into prompts at runtime as contextual grounding.

---

## AI Integration Function (PL/SQL)

The core integration is implemented using a PL/SQL function:

**`ask_chatbot_ai`**

This function acts as a wrapper between Oracle APEX and the Ollama REST API.

### Features
- Supports general chatbot interactions
- Supports business / SQL assistance mode
- Injects business context from Oracle Database
- Parses streaming JSON responses from Ollama
- Uses Oracle APEX REST utilities

---

## Usage Examples

The function can be invoked directly from SQL or from Oracle APEX page processes.

### General Chat Mode
Used for general questions and explanations.

```sql
SELECT ask_chatbot_ai(
    p_prompt => 'What is Oracle APEX?',
    p_type   => 'GENERAL'
) AS response
FROM dual;

Business / SQL Assistance Mode

Used for business or data model questions.
Business knowledge from the database is injected into the prompt.

SELECT ask_chatbot_ai(
    p_prompt => 'How many invoices are created today?',
    p_type   => 'SALES'
) AS response
FROM dual;
