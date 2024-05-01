# My Todo App - Client

This is the client side of the My Todo App. It is a React application that allows users to add, view, and delete todo items.

## Getting Started

First, you need to install the dependencies. Run the following command in the `client` directory:

```
npm install
```

Then, you can start the application with:

```
npm start
```

The application will be available at `http://localhost:3000`.

## Structure

The application is structured as follows:

- `src/App.js`: This is the main component. It renders the TodoList and AddTodo components, manages the state, and handles events.
- `src/index.js`: This is the entry point of the application. It renders the App component.
- `src/components/TodoList.js`: This component renders a list of TodoItem components.
- `src/components/TodoItem.js`: This component renders a single todo item.
- `src/components/AddTodo.js`: This component renders a form to add a new todo.
- `src/styles/App.css`: This file contains the CSS styles for the application.

## Environment Variables

The application uses the following environment variables:

- `REACT_APP_API_URL`: The URL of the API. It should be set to the URL of the server side of the project.

You can set these variables in the `.env` file.

## Building

You can build the application for production with:

```
npm run build
```

This will create a `build` directory with the production-ready files.

## Testing

You can run the tests with:

```
npm test
```

## Contributing

Please read the main `README.md` file for details on our code of conduct, and the process for submitting pull requests to us.

## License

This project is licensed under the MIT License - see the `LICENSE.md` file for details.