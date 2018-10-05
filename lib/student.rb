# Your connection to the database can be referred to, throughout your program, like this: `DB[:conn]`. So far we built the ability to create
# the students table in the database (`Student.create_table`), drop that table (`Student.drop_table`), and `#save` a student to the database.
# Now, we will need to create a method that takes a row from the database and turns it back into a Student object.
# We will call this `.new_from_db`. Next, we want to build a couple of methods to get information from the database.
# We will call these `.find_by_name` and `.all`.

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = #{}<<-SQL
        "SELECT *
        FROM students
        WHERE name = ?"
        #LIMIT 1"
        #SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
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

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?;"
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10;"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, x)
  end


  #   .students_below_12th_grade
  #     returns an array of all students in grades 11 or below (FAILED - 2)

  #   .first_student_in_grade_10
  #     returns the first student in grade 10 (FAILED - 4)
  #   .all_students_in_grade_X
  #     returns an array of all students in a given grade X (FAILED - 5)
end
