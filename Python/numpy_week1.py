"""
NumPy Week 1 Revision Notebook

Topics:
- Array Creation
- Array Attributes
- Zeros
- Ones
- Arange
- Linspace
- Random
- Reshape
- Practice Programs
"""

import numpy as np


# ============================================================
# Array Creation
# ============================================================
# Create NumPy arrays from Python lists.
numbers = np.array([10, 20, 30, 40, 50])
matrix = np.array([[1, 2, 3], [4, 5, 6]])

print("Array:", numbers)
print("Matrix:")
print(matrix)


# ============================================================
# Array Attributes
# ============================================================
# Check useful details about an array.
print("Shape:", matrix.shape)
print("Size:", matrix.size)
print("Dimensions:", matrix.ndim)
print("Data type:", matrix.dtype)


# ============================================================
# Zeros
# ============================================================
# Create arrays filled with zero values.
zeros_array = np.zeros((3, 4))
print("Zeros array:")
print(zeros_array)


# ============================================================
# Ones
# ============================================================
# Create arrays filled with one values.
ones_array = np.ones((2, 5))
print("Ones array:")
print(ones_array)


# ============================================================
# Arange
# ============================================================
# Create values using start, stop, and step.
even_numbers = np.arange(2, 21, 2)
print("Even numbers:", even_numbers)


# ============================================================
# Linspace
# ============================================================
# Create equal intervals between two values.
linear_values = np.linspace(0, 1, 5)
print("Linspace values:", linear_values)


# ============================================================
# Random
# ============================================================
# Create random integer and decimal arrays.
random_integers = np.random.randint(1, 100, size=(3, 3))
random_decimals = np.random.random((2, 3))

print("Random integers:")
print(random_integers)
print("Random decimals:")
print(random_decimals)


# ============================================================
# Reshape
# ============================================================
# Change the shape of an array without changing its data.
original_array = np.arange(1, 13)
reshaped_array = original_array.reshape(3, 4)

print("Original array:", original_array)
print("Reshaped array:")
print(reshaped_array)


# ============================================================
# Practice Programs
# ============================================================
# Program 1: Create a 3x3 array with numbers from 1 to 9.
practice_array = np.arange(1, 10).reshape(3, 3)
print("Practice array:")
print(practice_array)

# Program 2: Create an array of 10 prices and increase each price by 10%.
prices = np.array([100, 250, 400, 150, 600, 750, 900, 1200, 300, 500])
updated_prices = prices * 1.10
print("Updated prices:", updated_prices)

# Program 3: Create marks array and calculate total and average marks.
marks = np.array([78, 85, 92, 67, 74])
print("Total marks:", marks.sum())
print("Average marks:", marks.mean())

