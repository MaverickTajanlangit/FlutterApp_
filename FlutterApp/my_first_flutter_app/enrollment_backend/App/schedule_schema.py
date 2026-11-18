from datetime import time
from pydantic import BaseModel, ConfigDict, Field


class ScheduleCreate(BaseModel):
    subject_id: int = Field(gt=0)
    day_of_week: str = Field(min_length=1, max_length=20)
    start_time: time
    end_time: time
    room: str = Field(min_length=1, max_length=50)
    slot_capacity: int = Field(ge=1)


class ScheduleUpdate(BaseModel):
    subject_id: int | None = Field(default=None, gt=0)
    day_of_week: str | None = Field(default=None, max_length=20)
    start_time: time | None = None
    end_time: time | None = None
    room: str | None = Field(default=None, max_length=50)
    slot_capacity: int | None = Field(default=None, ge=1)


class ScheduleResponse(BaseModel):
    schedule_id: int
    subject_id: int
    day_of_week: str
    start_time: time
    end_time: time
    room: str
    slot_capacity: int

    model_config = ConfigDict(from_attributes=True)