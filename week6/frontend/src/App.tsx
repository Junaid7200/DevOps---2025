import { useState, useEffect } from 'react';
import type { Student } from './types/Student';
import { studentApi } from './services/api';
import StudentList from './components/StudentList';
import StudentForm from './components/StudentForm';
import './App.css';

function App() {
  const [students, setStudents] = useState<Student[]>([]);
  const [editingStudent, setEditingStudent] = useState<Student | null>(null);
  const [showForm, setShowForm] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      setLoading(true);
      const response = await studentApi.getAll();
      setStudents(response.data);
    } catch (error) {
      console.error('Error fetching students:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateStudent = async (studentData: Omit<Student, 'id'>) => {
    try {
      await studentApi.create(studentData);
      setShowForm(false);
      fetchStudents();
    } catch (error) {
      console.error('Error creating student:', error);
    }
  };

  const handleUpdateStudent = async (studentData: Omit<Student, 'id'>) => {
    if (!editingStudent) return;
    try {
      await studentApi.update(editingStudent.id!, studentData);
      setEditingStudent(null);
      setShowForm(false);
      fetchStudents();
    } catch (error) {
      console.error('Error updating student:', error);
    }
  };

  const handleDeleteStudent = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this student?')) {
      try {
        await studentApi.delete(id);
        fetchStudents();
      } catch (error) {
        console.error('Error deleting student:', error);
      }
    }
  };

  const handleEdit = (student: Student) => {
    setEditingStudent(student);
    setShowForm(true);
  };

  const handleCancel = () => {
    setEditingStudent(null);
    setShowForm(false);
  };

  return (
    <div className="App">
      <h1>Student Management System</h1>
      
      {!showForm && (
        <button onClick={() => setShowForm(true)}>Add New Student</button>
      )}

      {showForm && (
        <StudentForm
          student={editingStudent || undefined}
          onSubmit={editingStudent ? handleUpdateStudent : handleCreateStudent}
          onCancel={handleCancel}
        />
      )}

      {loading ? (
        <p>Loading...</p>
      ) : (
        <StudentList
          students={students}
          onEdit={handleEdit}
          onDelete={handleDeleteStudent}
        />
      )}
    </div>
  );
}

export default App;