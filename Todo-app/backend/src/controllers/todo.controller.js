import { pool } from '../config/db.js';
import { redis } from '../config/redis.js';

export const getTodos = async (req, res) => {
  const userId = req.user.id;
  const key = `todos:${userId}`;

  // 1. Check cache
  const cached = await redis.get(key);
  if (cached) return res.json(JSON.parse(cached));

  // 2. DB fetch
  const result = await pool.query(
    'SELECT * FROM todos WHERE user_id = $1',
    [userId]
  );

  // 3. Cache result
  await redis.setex(key, 60, JSON.stringify(result.rows));

  res.json(result.rows);
};

export const createTodo = async (req, res) => {
  const userId = req.user.id;
  const { title } = req.body;

  const result = await pool.query(
    'INSERT INTO todos (user_id, title) VALUES ($1, $2) RETURNING *',
    [userId, title]
  );

  // invalidate cache
  await redis.del(`todos:${userId}`);

  res.json(result.rows[0]);
};

export const deleteTodo = async (req, res) => {
  const userId = req.user.id;
  const { id } = req.params;

  await pool.query('DELETE FROM todos WHERE id=$1 AND user_id=$2', [id, userId]);

  await redis.del(`todos:${userId}`);

  res.json({ message: "Deleted" });
};