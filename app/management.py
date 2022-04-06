import json
import datetime
import time

from spartan import Spartan
from pymongo import MongoClient

# with open("database.config") as config_file:
#     database_url = config_file.read().strip()
while True:
    try:
        client = MongoClient("/database.config")
        break
    except Exception as e:
        print("trying to create a connection to the database")
        time.sleep(2)

db = client.spartan_test

def log(action):
    try:
        with open("log/spartan_log.txt", "a+") as log_txt:
            logging = datetime.datetime.now()
            current_date = logging.strftime("%d-%m-%Y %H:%M:%S")
            log_txt.write(f"\n{current_date} ---- {action}")

    except Exception:
        return "File not found"

def read_sparta_id(spartan_id):

    try:
        if spartan_id > 0:
            return spartan_id
        else:
            return False

    except Exception as ex:
        return False



def read_name(name_str):
    name_str = str(name_str)
    if len(name_str.strip()) >= 2:
        return name_str
    else:
        return False


def read_text(course_str):
    course_str = str(course_str)
    course = course_str.strip()

    if len(str(course)) >= 2:
        return course_str
    else:
        return False


def read_year(year_str):
    year_str = str(year_str)
    try:
        if year_str.isdigit():
            year = int(year_str.strip())
            if (year >= 1900) and (year <= 2004):
                return year
            else:
                return False
    except Exception as ex:
        return False


def read_month(month_str):
    month_str = str(month_str)
    try:
        if month_str.isdigit():
            month = int(month_str.strip())
            if (month >= 1) and (month <= 12):
                return month
            else:
                return False
    except Exception as ex:
        return False


def read_day(day_str):
    day_str = str(day_str)
    try:
        if day_str.isdigit():
            day = int(day_str.strip())
            if (day >= 1) and (day <= 31):
                return day
            else:
                return False
    except Exception:
        return False

def spartan_id_get(sparta_id):

    sparta_id_int = int(sparta_id)
    sparta_emp = db.employees.find_one({"spartan_id" : sparta_id_int})
    str_sparta = str(sparta_emp)
    return str_sparta



def adding_spartan(sparta_data):

    try:
        sparta_id = read_sparta_id(sparta_data['spartan_id'])
    except Exception:
        log("User did not enter a positive number for Spartan ID")
        return "Error, Spartan ID must be a positive number"

    if db.employees.find_one({"spartan_id": sparta_id}):
        return "Error, ID already in database"

    if sparta_id == False:
        log("User did not enter a positive number for Spartan ID")
        return "Error, Spartan ID must be a positive number 1"

    first_name_v = read_name(sparta_data['first_name'])
    if first_name_v == False:
        log("User tried to enter a First name with less than two characters")
        return "First name must be more than one character"

    last_name = read_name(sparta_data['last_name'])
    if last_name == False:
        log("User tried to enter a Last name with less than two characters")
        return "Last Name must be more than one character"

    birth_year = read_year(sparta_data['birth_year'])
    if birth_year == False:
        log("User tried to enter a Birth Year not between 1900-2000")
        return "Birth year must be a digit and between 1900-2000"

    birth_month = read_month(sparta_data['birth_month'])
    if birth_month == False:
        log("User tried to enter a Birth month not between 1-12")
        return "Birth month must be a digit and between 1-12"

    birth_day = read_day(sparta_data['birth_day'])
    if birth_day == False:
        log("User tried to enter a Birth day not between 1-31")
        return "Birth day must be a digit and between 1-31"

    course = read_text(sparta_data['course'])
    if course == False:
        log("User tried to enter a Course with more than 1 characters")
        return "Course must be more than 1 character"

    stream = read_text(sparta_data['stream'])
    if stream == False:
        log("User tried to enter a Stream with more than 1 characters")
        return "Stream must be more than 1 character"

    else:

        trainee_obj = Spartan(sparta_id, first_name_v, last_name,
                                birth_year, birth_month, birth_day,
                                course, stream)

        sparta_dict_json = trainee_obj.__dict__

        print(sparta_dict_json)

        db.employees.insert_one(sparta_dict_json)

        return f"Spartan ID: {trainee_obj.get_spartan_id()}'s details have been successfully added to the system"


def list_spartans():
    documents = db.employees.find()
    response_list = []
    for document in documents:
        document['_id'] = str(document['_id'])
        response_list.append(document)
    return response_list

    # if db.employees.find_one() == None:
    #     return "Error, No data found"
    # else:
    #     spartan_list = db.employees.find_one()
    #     return spartan_list

def remove_spartan(id_to_remove):

    try:
        sparta_id = read_sparta_id(id_to_remove)
    except Exception:
        log("User did not enter a positive number for Spartan ID")
        return "Error, Spartan ID must be a positive number"

    if not db.employees.find_one({"spartan_id": sparta_id}):
        return "Error, ID not in database"

    db.employees.delete_one({"spartan_id" : sparta_id})


    log("User successfully removed an Spartan")
    return f"User successfully removed: {id_to_remove}"



