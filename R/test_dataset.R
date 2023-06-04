# Create a new Dataset object
myDataset <- new("Dataset")

# Initialize the Dataset object with some data
data <- data.frame(
  Name = c("John", "Alice", "Bob"),
  Age = c(25, 30, 35),
  Gender = c("Male", "Female", "Male")
)
myDataset <-initialize(myDataset, data)

# Read data from a file and load it into the Dataset object
#read_data(myDataset, "data.csv")

# Write the data from the Dataset object to a file
write_data(myDataset, "output.csv")

# Get the values of a specific attribute
nameValues <- get_attribute(myDataset, "Name")
ageValues <- get_attribute(myDataset, "Age")
genderValues <- get_attribute(myDataset, "Gender")

# Add a new attribute to the dataset
salaryValues <- c(50000, 60000, 70000)
add_attribute(myDataset, "Salary", salaryValues)

# Set the values of an existing attribute
set_attribute(myDataset, "Age", c(26, 31, 36))

# Get the list of attribute names
attributeNames <- get_attributes(myDataset)

# Get the underlying data frame
dataFrame <- get_data(myDataset)

# Check if the dataset is empty
isEmpty <- empty(myDataset)

# Create a copy of the dataset
copyDataset <- copy(myDataset)

# Get the number of attributes in the dataset
numAttributes <- num_attributes(myDataset)

# Show the help text
show_help()
