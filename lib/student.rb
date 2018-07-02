require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    self.name = name 
    self.grade = grade
    @id = id
    self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql =  <<-SQL 
      DROP TABLE students
    SQL
    
    DB[:conn].execute(sql) 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)
    
    @id = DB[:conn].execute('SELECT id FROM students ORDER BY id DESC LIMIT 1')[0][0]
  end
  
  def self.create(name, grade)
    new(name, grade).tap { |pupil| pupil.save }
  end
  
  def self.new_from_db(row)
    new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row[1], row[2], row[0])
    end.first
  end
  
  def update
    # makes DB match object
  end
  
end
