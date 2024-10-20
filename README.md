# Giselle Backend - Ballerina Project

## Overview

Giselle is an online platform designed to simplify the online presence of retail clothing stores. By integrating multiple stores into one platform, it provides customers a unified shopping experience, offering features like semantic search, image search, and more. This project uses Ballerina as the primary backend language for managing REST APIs, gRPC services, and database interactions, enabling seamless integration with other services such as machine learning models and external systems.

## Features

- **REST API**: Handles user authentication, product retrieval, and other core functionality via REST.
- **gRPC Services**: Manages interactions with external services, particularly for searching and data fetching.
- **Graphic Services**: Manages large schemas and interactions with external graphic-related services.
- **Database Interactions**: Handles all interactions with the database, including storing and retrieving data.

## Project Structure

- **main.bal**: Contains the main REST API endpoints and handles requests for the platform's core functionalities such as user interactions and product management.
- **graphic_services.bal**: Manages graphic-related operations, such as handling large schemas and working with external graphic servers.
- **search_service_pb.bal**: Implements the gRPC services to communicate with other backend services, especially for executing search tasks.
- **modules/rest**: Contains the modules that interact with the database, handling CRUD operations and data management.

## Technologies Used

- **Ballerina**: A cloud-native, microservices-focused programming language used for backend services.
- **gRPC**: Used for efficient communication with other backend services, particularly for search functionality.
- **REST API**: Exposes endpoints for frontend interaction, such as product listing, authentication, and more.
- **Auth0**: Provides secure authentication and authorization for the users.
- **Kafka**: Manages communication between different services for real-time data processing.
- **PostgreSQL**: Used as the primary database to manage persistent storage.

## Prerequisites

- Ballerina installed on your system.
- Docker installed for containerization.
- PostgreSQL (or your preferred database) for managing data.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/giselle-ballerina/iwb449-giselle-backend-ballerina.git
   ```
2. Navigate to the project directory:
    ```bash
   cd iwb449-giselle-backend-ballerina

   ```
3. Build the Docker Image
    ```bash
    docker build -t giselle-backend .
    ```
4. Run the container 
    ```bash
    docker run -d -p 9090:9090 -p 9091:9091 giselle-backend
    ```
6. Backend services should now be running.
    ```bash
    http://localhost:9090
    http://localhost:9091
    
    ```
we have a hosted version of the backend at 
    ```bash
    http://139.59.246.168:9090
    http://139.59.246.168:9091
    
    ```