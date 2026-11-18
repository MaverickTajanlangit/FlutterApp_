
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, EmailStr, Field


class StudentCreate(BaseModel):
    student_number: str = Field(min_length=1, max_length=30)
    student_name: str = Field(min_length=1, max_length=100)
    email: EmailStr
    course: str = Field(min_length=1, max_length=100)
    year_level: int = Field(ge=1, le=4)

    program_id: Optional[int] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    contact_number: Optional[str] = None


class StudentUpdate(BaseModel):
    student_number: Optional[str] = Field(default=None, max_length=30)
    student_name: Optional[str] = Field(default=None, max_length=100)
    email: Optional[EmailStr] = None
    course: Optional[str] = Field(default=None, max_length=100)
    year_level: Optional[int] = Field(default=None, ge=1, le=4)

    program_id: Optional[int] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    contact_number: Optional[str] = None


class StudentResponse(BaseModel):
    student_id: int
    student_number: Optional[str] = None
    student_name: Optional[str] = None
    email: Optional[str] = None
    course: Optional[str] = None
    year_level: Optional[int] = None
    program_id: Optional[int] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    contact_number: Optional[str] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
