import express from 'express';
import { auth } from '../middleware/auth.js';
import {
  getTodos,
  createTodo,
  deleteTodo
} from '../controllers/todo.controller.js';

const router = express.Router();

router.get('/', auth, getTodos);
router.post('/', auth, createTodo);
router.delete('/:id', auth, deleteTodo);

export default router;