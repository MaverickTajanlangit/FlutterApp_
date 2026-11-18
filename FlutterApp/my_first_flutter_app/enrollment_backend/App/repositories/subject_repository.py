from sqlalchemy.orm import Session
from App.models_subject import Subject
from App.schemas_subject import SubjectCreate, SubjectUpdate


def get_all_subjects(db: Session):
    return db.query(Subject).order_by(Subject.subject_id).all()


def get_subject(db: Session, subject_id: int):
    return db.query(Subject).filter(
        Subject.subject_id == subject_id
    ).first()


def create_subject(db: Session, subject_data: SubjectCreate):
    subject = Subject(**subject_data.model_dump())
    db.add(subject)
    db.commit()
    db.refresh(subject)
    return subject


def update_subject(
    db: Session,
    subject_id: int,
    subject_data: SubjectUpdate
):
    subject = get_subject(db, subject_id)

    if not subject:
        return None

    update_data = subject_data.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(subject, key, value)

    db.commit()
    db.refresh(subject)
    return subject


def delete_subject(db: Session, subject_id: int):
    subject = get_subject(db, subject_id)

    if not subject:
        return False

    db.delete(subject)
    db.commit()
    return True