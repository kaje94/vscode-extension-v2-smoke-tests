import React, { Component } from 'react';
import TodoList from './components/TodoList';
import AddTodo from './components/AddTodo';
import './styles/App.css';

class App extends Component {
  state = {
    todos: []
  };

  componentDidMount() {
    fetch(`${process.env.REACT_APP_API_URL}/todos`)
      .then(res => res.json())
      .then(todos => this.setState({ todos }));
  }

  addTodo = (title) => {
    fetch(`${process.env.REACT_APP_API_URL}/todos`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ title }),
    })
      .then(res => res.json())
      .then(todo => this.setState({ todos: [...this.state.todos, todo] }));
  }

  deleteTodo = (id) => {
    fetch(`${process.env.REACT_APP_API_URL}/todos/${id}`, {
      method: 'DELETE',
    })
      .then(() => {
        this.setState({ todos: this.state.todos.filter(todo => todo.id !== id) });
      });
  }

  render() {
    return (
      <div className="App">
        <h1>Todo List</h1>
        <AddTodo addTodo={this.addTodo} />
        <TodoList todos={this.state.todos} deleteTodo={this.deleteTodo} />
      </div>
    );
  }
}

export default App;
