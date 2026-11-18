
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from sqlalchemy import text
from App.routers.subjects import router as subjects_router

from App.database import get_db
from App.models import Student
from App.schemas import (
    StudentCreate,
    StudentUpdate,
    StudentResponse
)

app = FastAPI(
    title="Student Enrollment System API",
    description="Backend API for the Flutter Student Enrollment System",
    version="1.0.0"
)

app.include_router(subjects_router)

# Allow Flutter Web and Android Emulator to access the API.
# This configuration is intended for local development.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def home():
    return {
        "message": "Student Enrollment System API is running!"
    }


@app.get("/api/health")
def health_check(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {
            "status": "healthy",
            "database": "connected"
        }
    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Database connection failed."
        )


@app.get("/students", response_model=list[StudentResponse])
def get_students(db: Session = Depends(get_db)):
    students = db.query(Student).order_by(Student.student_id).all()
    return students


@app.get("/students/{student_id}", response_model=StudentResponse)
def get_student(student_id: int, db: Session = Depends(get_db)):
    student = db.query(Student).filter(
        Student.student_id == student_id
    ).first()

    if not student:
        raise HTTPException(
            status_code=404,
            detail="Student not found."
        )

    return student


@app.post("/students", response_model=StudentResponse, status_code=201)
def create_student(
    student_data: StudentCreate,
    db: Session = Depends(get_db)
):
    student = Student(**student_data.model_dump())

    try:
        db.add(student)
        db.commit()
        db.refresh(student)
        return student

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Student number or email already exists, or a related database constraint was violated."
        )


@app.put("/students/{student_id}", response_model=StudentResponse)
def update_student(
    student_id: int,
    student_data: StudentUpdate,
    db: Session = Depends(get_db)
):
    student = db.query(Student).filter(
        Student.student_id == student_id
    ).first()

    if not student:
        raise HTTPException(
            status_code=404,
            detail="Student not found."
        )

    update_data = student_data.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(student, key, value)

    try:
        db.commit()
        db.refresh(student)
        return student

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Student number or email already exists, or a related database constraint was violated."
        )


@app.delete("/students/{student_id}")
def delete_student(student_id: int, db: Session = Depends(get_db)):
    student = db.query(Student).filter(
        Student.student_id == student_id
    ).first()

    if not student:
        raise HTTPException(
            status_code=404,
            detail="Student not found."
        )

    try:
        db.delete(student)
        db.commit()

        return {
            "message": "Student deleted successfully."
        }

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="This student cannot be deleted because enrollment or grade records are linked to this student."
        )
