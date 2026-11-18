from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

from App.database import get_db
from App.schemas_subject import (
    SubjectCreate,
    SubjectUpdate,
    SubjectResponse
)
from App.repositories import subject_repository

router = APIRouter(prefix="/subjects", tags=["Subjects"])


@router.get("/", response_model=list[SubjectResponse])
def get_subjects(db: Session = Depends(get_db)):
    return subject_repository.get_all_subjects(db)


@router.get("/{subject_id}", response_model=SubjectResponse)
def get_subject(subject_id: int, db: Session = Depends(get_db)):
    subject = subject_repository.get_subject(db, subject_id)

    if not subject:
        raise HTTPException(status_code=404, detail="Subject not found.")

    return subject


@router.post("/", response_model=SubjectResponse, status_code=201)
def create_subject(
    subject_data: SubjectCreate,
    db: Session = Depends(get_db)
):
    try:
        return subject_repository.create_subject(db, subject_data)
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Subject code already exists or a database constraint was violated."
        )


@router.put("/{subject_id}", response_model=SubjectResponse)
def update_subject(
    subject_id: int,
    subject_data: SubjectUpdate,
    db: Session = Depends(get_db)
):
    try:
        subject = subject_repository.update_subject(
            db, subject_id, subject_data
        )

        if not subject:
            raise HTTPException(status_code=404, detail="Subject not found.")

        return subject

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Subject code already exists or a database constraint was violated."
        )


@router.delete("/{subject_id}")
def delete_subject(subject_id: int, db: Session = Depends(get_db)):
    try:
        deleted = subject_repository.delete_subject(db, subject_id)

        if not deleted:
            raise HTTPException(status_code=404, detail="Subject not found.")

        return {"message": "Subject deleted successfully."}

    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=409,
            detail="This subject cannot be deleted because schedule or enrollment records are linked to it."
        )