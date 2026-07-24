"""
NumPy Week 2 Revision Notebook

Topics:
- Indexing
- Slicing
- Flatten
- Ravel
- Transpose
- Sum
- Mean
- Median
- Min
- Max
- Std
- Var
- Argmax
- Argmin
- Cumsum
- Practice Programs
"""

import numpy as np

data = np.array([
    [10, 20, 30],
    [40, 50, 60],
    [70, 80, 90]
])


# ============================================================
# Indexing
# ============================================================
# Access single elements using row and column positions.
print("Element at row 1, column 2:", data[1, 2])


# ============================================================
# Slicing
# ============================================================
# Extract selected rows, columns, or ranges.
print("First two rows:")
print(data[:2])
print("Second column:", data[:, 1])


# ============================================================
# Flatten
# ============================================================
# Convert a multi-dimensional array into a 1D copy.
flattened_data = data.flatten()
print("Flattened array:", flattened_data)


# ============================================================
# Ravel
# ============================================================
# Convert a multi-dimensional array into a 1D view when possible.
raveled_data = data.ravel()
print("Raveled array:", raveled_data)


# ============================================================
# Transpose
# ============================================================
# Convert rows into columns and columns into rows.
transposed_data = data.T
print("Transposed array:")
print(transposed_data)


# ============================================================
# Sum
# ============================================================
# Calculate total values for an array.
print("Total sum:", np.sum(data))
print("Column-wise sum:", np.sum(data, axis=0))


# ============================================================
# Mean
# ============================================================
# Calculate average values.
print("Mean:", np.mean(data))
print("Row-wise mean:", np.mean(data, axis=1))


# ============================================================
# Median
# ============================================================
# Find the middle value.
print("Median:", np.median(data))


# ============================================================
# Min
# ============================================================
# Find the smallest value.
print("Minimum:", np.min(data))


# ============================================================
# Max
# ============================================================
# Find the largest value.
print("Maximum:", np.max(data))


# ============================================================
# Std
# ============================================================
# Calculate standard deviation.
print("Standard deviation:", np.std(data))


# ============================================================
# Var
# ============================================================
# Calculate variance.
print("Variance:", np.var(data))


# ============================================================
# Argmax
# ============================================================
# Find the index position of the maximum value.
print("Argmax:", np.argmax(data))


# ============================================================
# Argmin
# ============================================================
# Find the index position of the minimum value.
print("Argmin:", np.argmin(data))


# ============================================================
# Cumsum
# ============================================================
# Calculate cumulative sum.
print("Cumulative sum:", np.cumsum(data))


# ============================================================
# Practice Programs
# ============================================================
# Program 1: Analyze monthly sales data.
monthly_sales = np.array([12000, 15000, 17000, 14000, 22000, 25000])
print("Total sales:", np.sum(monthly_sales))
print("Average sales:", np.mean(monthly_sales))
print("Highest sales month index:", np.argmax(monthly_sales))

# Program 2: Analyze student marks.
student_marks = np.array([
    [78, 85, 90],
    [88, 76, 95],
    [92, 89, 84]
])
print("Student-wise total marks:", np.sum(student_marks, axis=1))
print("Subject-wise average marks:", np.mean(student_marks, axis=0))

# Program 3: Compare product prices.
product_prices = np.array([999, 1299, 499, 2499, 1899])
print("Cheapest product price:", np.min(product_prices))
print("Most expensive product price:", np.max(product_prices))
print("Sorted prices:", np.sort(product_prices))

