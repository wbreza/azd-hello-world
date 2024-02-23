// Importing required modules
import express from 'express';

// Creating an Express application
const app = express();

// Define a route to handle GET requests to the root URL
app.get('/', (req, res) => {
    res.send('Hello, World!');
});

const port = process.env.PORT || 3000;

// Starting the server on port 3000
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
