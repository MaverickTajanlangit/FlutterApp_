
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func

from App.database import Base


class Student(Base):
    __tablename__ = "students"

    # Existing primary key
    student_id = Column(Integer, primary_key=True, index=True)

    # Existing student information
    student_name = Column(String(100), nullable=True)
    program_id = Column(Integer, nullable=True)

    student_number = Column(String(30), nullable=True, unique=True)
    first_name = Column(String(50), nullable=True)
    last_name = Column(String(50), nullable=True)

    email = Column(String(255), nullable=True, unique=True)
    course = Column(String(100), nullable=True)
    year_level = Column(Integer, nullable=True)

    contact_number = Column(String(30), nullable=True)

    # Existing database timestamp
    created_at = Column(
        DateTime,
        nullable=False,
        server_default=func.current_timestamp()
    )
