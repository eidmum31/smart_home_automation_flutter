class ApiFeatures {
  constructor(query, queryString) {
    this.query = query;
    this.queryString = queryString;
  }
  filter() {
    const queryObj = { ...this.queryString };
    const excludeFields = ["limit", "sort", "fields", "page"];
    excludeFields.forEach((el) => {
      delete queryObj[el];
    });
    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(/\b(gte|gt|lt|lte)\b/g, (match) => `$${match}`);

    this.query = this.query.find(JSON.parse(queryStr));

    return this;
  }
  sort() {
    if (this.queryString.sort) {
      this.query = this.query.sort(this.queryString.sort.split(",").join(" "));
    } else {
      this.query = this.query.sort("createAt");
    }
    return this;
  }
  limitFields() {
    if (this.queryString.fields) {
      this.query = this.query.select(
        this.queryString.fields.split(",").join(" ")
      );
    } else {
      this.query = this.query.select("-__v");
    }
    return this;
  }
  paginate() {
    const skip =
      (this.queryString.page - 1 * 1) * (this.queryString.limit * 1) || 0;
    const limit = this.queryString.limit * 1 || 100;

    this.query = this.query.skip(skip).limit(limit);
    return this;
  }
}
module.exports = ApiFeatures;
