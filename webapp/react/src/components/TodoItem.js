import React from 'react';
import PropTypes from 'prop-types';

function TodoItem({ todo, toggleComplete, deleteTodo }) {
  const { id, title, completed } = todo;

  return (
    <div>
      <input type="checkbox" checked={completed} onChange={() => toggleComplete(id)} />
      <span style={completed ? { textDecoration: 'line-through' } : null}>{title}</span>
      <button onClick={() => deleteTodo(id)}>Delete</button>
    </div>
  );
}

TodoItem.propTypes = {
  todo: PropTypes.shape({
    id: PropTypes.number.isRequired,
    title: PropTypes.string.isRequired,
    completed: PropTypes.bool.isRequired,
  }).isRequired,
  toggleComplete: PropTypes.func.isRequired,
  deleteTodo: PropTypes.func.isRequired,
};

export default TodoItem;