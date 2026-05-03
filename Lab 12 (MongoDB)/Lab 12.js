/*CL2006 - DATABASE SYSTEMS - LAB 12 - BAI-4A - 24K-0017*/

// Lab 12 - START

// Pre-Lab Instructions: Starting MongoDB

/*Step 1: Open Command Prompt or Terminal*/

/*Step 2: Start MongoDB Server (mongod)
Navigate to MongoDB bin folder, e.g.:
cd C:\Program Files\MongoDB\Server\6.0\bin
Then run:
mongod
(Keep this terminal open — this is your database engine running)*/

/*Step 3: Open another terminal and start Mongo Shell:
mongosh
(You are now connected to MongoDB)*/

/*Optional:
To check connection:
show dbs
*/

// Q1) MongoDB Basics

/*(a) Create a database named LibraryDB and a collection of Books.
Insert 3 documents with fields: title, author, year*/

use LibraryDB

db.Books.insertMany([
  { title: "Atomic Habits", author: "James Clear", year: 2018 },
  { title: "Deep Work", author: "Cal Newport", year: 2016 },
  { title: "Clean Code", author: "Robert C. Martin", year: 2008 }
])

/*(b) Write queries to:
Find all documents
Find books published after 2015*/

// Find all books
db.Books.find()

// Books after 2015
db.Books.find({ year: { $gt: 2015 } })


// Q2) Logical Operators

/*(A) Find users where:
Age > 25 AND subscriptionType = "Premium"*/

db.Users.find({
  age: { $gt: 25 },
  subscriptionType: "Premium"
})

/*(B) Retrieve orders where:
totalAmount > 5000 OR status = "Pending"*/

db.Orders.find({
  $or: [
    { totalAmount: { $gt: 5000 } },
    { status: "Pending" }
  ]
})


// Q3) Advanced Queries

/*(A) Bookstore tasks:
Count books with sales > 1000
Sort books by sales descending
Limit top 3 books*/

// Count
db.Bookstore.countDocuments({ sales: { $gt: 1000 } })

// Sort descending
db.Bookstore.find().sort({ sales: -1 })

// Top 3
db.Bookstore.find().sort({ sales: -1 }).limit(3)


/*(B) Blogging platform:
Find posts where:
likes > 100
tag includes "tech"
comments count > 2*/

db.Posts.find({
  likes: { $gt: 100 },
  tags: "tech",
  $expr: { $gt: [ { $size: "$comments" }, 2 ] }
})

// Q4) Aggregation Pipeline

/*Ride-hailing app:
Find total revenue per city
Show only cities with revenue > 50,000
Sort descending*/

db.Trips.aggregate([
  {
    $group: {
      _id: "$city",
      totalRevenue: { $sum: "$fare" }
    }
  },
  {
    $match: {
      totalRevenue: { $gt: 50000 }
    }
  },
  {
    $sort: { totalRevenue: -1 }
  }
])


// Q5) Mixed Operations

/*Find products where price < 1000 AND stock > 0*/

db.Products.find({
  price: { $lt: 1000 },
  stock: { $gt: 0 }
})

/*Update stock by decreasing 5 for category "Electronics"*/

db.Products.updateMany(
  { category: "Electronics" },
  { $inc: { stock: -5 } }
)

/*Group by category and count products*/

db.Products.aggregate([
  {
    $group: {
      _id: "$category",
      count: { $sum: 1 }
    }
  }
])

/*Perform text search on productName*/

db.Products.createIndex({ productName: "text" })

db.Products.find({
  $text: { $search: "laptop" }
})

// Lab 12 - END
