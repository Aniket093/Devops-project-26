FROM node:18-alpine

# Creates working directory inside container
WORKDIR /app

# Copies dependency file first
COPY package.json .

# Installs Node.js dependencies
RUN npm install

# Copies remaining application files
COPY . .

EXPOSE 3000

# Start the application
CMD ["npm", "start"]