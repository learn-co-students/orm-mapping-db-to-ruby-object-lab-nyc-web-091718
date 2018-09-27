require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.map {|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name).flatten
    Student.new_from_db(row)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.each {|row| Student.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < 12
    SQL
    student_rows = DB[:conn].execute(sql)
    student_rows.map {|row| Student.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(arg)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 limit ?
    SQL
    rows = DB[:conn].execute(sql,arg)
    rows.map {|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students where grade = 10 limit 1
    SQL
    Student.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    student_rows = DB[:conn].execute(sql, grade)
    student_rows.map{|row| Student.new_from_db(row)}
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
