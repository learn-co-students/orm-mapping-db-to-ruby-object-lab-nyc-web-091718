require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new()
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all

    sql = <<-sql
      SELECT * FROM STUDENTS
    sql

    all_students_raw = DB[:conn].execute(sql)

    all_students_raw.map{|array| Student.new_from_db(array)}

    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-sql
      SELECT * FROM students WHERE students.name = (?)
    sql

    temp = DB[:conn].execute(sql,name).flatten
    student = self.new_from_db(temp)
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    sql = <<-sql
      SELECT * FROM students WHERE students.grade = 9
      sql
    temp_array = DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-sql
      SELECT * FROM students WHERE students.grade = 10 LIMIT 1
      sql
    Student.new_from_db (DB[:conn].execute(sql).flatten)
  end

  def self.first_X_students_in_grade_10(amount)
    sql = <<-sql
    SELECT * FROM students WHERE students.grade = 10 LIMIT (?)
    sql
    DB[:conn].execute(sql,amount).map{|array| Student.new_from_db(array)}
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-sql
    SELECT * FROM students WHERE students.grade = (?)
    sql

    DB[:conn].execute(sql,grade).map{|array| Student.new_from_db(array)}

  end

  def self.students_below_12th_grade
    sql = <<-sql
      SELECT * FROM students WHERE students.grade < 12
      sql
    temp_array = DB[:conn].execute(sql)
    temp_array.map{|array| Student.new_from_db(array)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
