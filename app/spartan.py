

class Spartan:

    def __init__(self, s_id, f_name,
                 l_name, b_year, b_month,
                 b_day, course, stream):
        self.spartan_id = s_id
        self.first_name = f_name
        self.last_name = l_name
        self.birth_year = b_year
        self.birth_month = b_month
        self.birth_day = b_day
        self.course = course
        self.stream = stream

    def get_spartan_id(self):
        return self.spartan_id

    def get_first_name(self):
        return self.first_name

    def get_last_name(self):
        return self.last_name

    def get_birth_year(self):
        return self.birth_year

    def get_birth_month(self):
        return self.birth_month

    def get_birth_day(self):
        return self.birth_day

    def get_course(self):
        return self.course

    def get_stream(self):
        return self.stream

    def set_spartan_id(self, new_id):
        self.spartan_id = new_id

    def set_first_name(self, new_f_name):
        self.first_name = new_f_name

    def set_last_name(self, new_l_name):
        self.last_name = new_l_name

    def set_birth_year(self, new_b_year):
        self.birth_year = new_b_year

    def set_birth_month(self, new_b_month):
        self.birth_month = new_b_month

    def set_birth_day(self, new_b_day):
        self.birth_day = new_b_day

    def set_course(self, n_course):
        self.course = n_course

    def print_all(self):
        return(f"""
Spartan ID = {self.spartan_id}
First Name = {self.first_name} 
Last Name = {self.last_name}
D.O.B = {self.birth_day}/{self.birth_month}/{self.birth_year}
Course = {self.course}                    
Stream = {self.stream}
""")

    def set_stream(self, n_stream):
        self.stream = n_stream
