require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
     )
    SQL
    DB[:conn].execute(sql)    
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if not self.id
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    id_return = <<-SQL
    SELECT id
    FROM students
    WHERE name = '#{self.name}'
    SQL
    @id = DB[:conn].execute(id_return)[0][0]
    else
      sql = <<-SQL
      UPDATE students
      SET name = '#{self.name}'
      WHERE id = '#{self.id}'
      SQL
      DB[:conn].execute(sql)
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = '#{name}'
    SQL
    row = DB[:conn].execute(sql)[0]
    self.new_from_db(row)  
  end

  def update
    Student.find_by_name(self.name)

  end



  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
