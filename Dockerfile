# Use the official Node.js image from the Docker Hub
FROM node:14-alpine

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application code to the working directory
COPY . .

# Expose the application port
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
