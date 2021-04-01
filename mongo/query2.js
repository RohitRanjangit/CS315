use mongo_db
var dummyA = db.A.find()
var dummyB = db.B.find()
db.B.explain("executionStats").aggregate([ { $sort : {B3:1} } ])