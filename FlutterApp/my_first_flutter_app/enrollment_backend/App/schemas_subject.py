from typing import Optional
from pydantic import BaseModel, ConfigDict, Field


class SubjectCreate(BaseModel):
    subject_code: str = Field(min_length=1, max_length=20)
    subject_name: str = Field(min_length=1, max_length=100)
    units: int = Field(ge=1)
    description: Optional[str] = None


class SubjectUpdate(BaseModel):
    subject_code: Optional[str] = Field(default=None, max_length=20)
    subject_name: Optional[str] = Field(default=None, max_length=100)
    units: Optional[int] = Field(default=None, ge=1)
    description: Optional[str] = None


class SubjectResponse(BaseModel):
    subject_id: int
    subject_code: str
    subject_name: str
    units: int
    description: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)