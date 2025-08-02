import axios from 'axios';
import type { Student } from '../types/Student.ts';

const API_BASE_URL = 'http://localhost:8000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const studentApi = {
  getAll: () => api.get<Student[]>('/students/'),
  getById: (id: number) => api.get<Student>(`/students/${id}/`),
  create: (student: Omit<Student, 'id'>) => api.post<Student>('/students/', student),
  update: (id: number, student: Omit<Student, 'id'>) => api.put<Student>(`/students/${id}/`, student),
  delete: (id: number) => api.delete(`/students/${id}/`),
};