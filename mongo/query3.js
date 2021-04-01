use mongo_db
var dummyA = db.A.find()
var dummyB = db.B.find()
db.B.explain("executionStats").aggregate([{$group:{_id:"$B2", count: {$sum: 1}}}])