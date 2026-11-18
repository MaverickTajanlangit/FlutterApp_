from sqlalchemy.orm import Session
from App.schedule_model import Schedule
from App.schedule_schema import ScheduleCreate, ScheduleUpdate

def get_all_schedules(db: Session):
    return db.query(Schedule).order_by(Schedule.schedule_id).all()