from sqlalchemy import Column, Integer, String, Text
from App.database import Base


class Subject(Base):
    __tablename__ = "subjects"

    subject_id = Column(Integer, primary_key=True, index=True)
    subject_code = Column(String(20), nullable=False, unique=True)
    subject_name = Column(String(100), nullable=False)
    units = Column(Integer, nullable=False)
    description = Column(Text, nullable=True)