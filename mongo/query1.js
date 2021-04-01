use mongo_db
var dummyA = db.A.find()
var dummyB = db.B.find()
db.A.explain("executionStats").find({ A1: {$lte : 50}})