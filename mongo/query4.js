use mongo_db
var dummyA = db.A.find()
var dummyB = db.B.find()
db.B.explain("executionStats").aggregate( [ { $lookup: { from: "A", localField: "B2", foreignField: "A1", as: "_A" }} ,{ $project: { B1:1, B2:1,B3:1,"_A.A2":1 }} ] ,{"allowDiskUse":true})