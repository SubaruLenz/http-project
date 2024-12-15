from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
import os
import asyncpg
import uvicorn

#Database connection
load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL")
async def test_db_connection():
  try:
    conn = await asyncpg.connect(DATABASE_URL)
    await conn.close()
    return True
  except Exception as e:
    print(f"ErrorL {e}")
    return False

#Define model
class Template(BaseModel):
   id: int
   title: str
   body: str

#Call
async def fetch_template_by_id(id: int) -> Template:
    try:
        conn = await asyncpg.connect(DATABASE_URL)
        query = "SELECT id, title, body FROM test_table WHERE id = $1"
        row = await conn.fetchrow(query, id)
        await conn.close()

        if row:
            return Template(id=row["id"], title=row["title"], body=row["body"])
        else:
            return None
    except Exception as e:
        print(f"Error fetching template: {e}")
        return None

#Start
app = FastAPI()

#Test connection
@app.get("/test-db")
async def test_db():
    if await test_db_connection():
        return {"message": "Database connection successful!"}
    else:
        raise HTTPException(status_code=500, detail="Failed to connect to the database")
    
#Main app
@app.get("/template/{id}", response_model=Template)
async def get_template(id: int):
    template = await fetch_template_by_id(id)
    if template:
        return template
    else:
        return {"error": "Template not found"}