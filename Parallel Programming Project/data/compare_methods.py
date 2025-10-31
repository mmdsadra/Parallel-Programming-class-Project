import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read all three CSV files
df1 = pd.read_csv('data_met1_cleaned.csv')
df2 = pd.read_csv('data_met2_cleaned.csv')
df3 = pd.read_csv('data_met3_cleaned.csv')

# Extract the column names (array sizes)
array_sizes = df1.columns.tolist()
# Convert array sizes to actual numbers (e.g., "10^2" to 100)
array_sizes_numeric = [eval(size.replace('^', '**')) for size in array_sizes]

# Calculate statistics for each method
mean_times1 = df1.mean()
mean_times2 = df2.mean()
mean_times3 = df3.mean()

std_times1 = df1.std()
std_times2 = df2.std()
std_times3 = df3.std()

# Set style for better aesthetics
plt.style.use('seaborn-v0_8-darkgrid')

# Create the comparison plot
fig, ax = plt.subplots(figsize=(12, 6))

# Define colors for each method
colors = ['#2E86AB', '#E63946', '#06A77D']  # Blue, Red, Green
labels = ['Array Addition', 'Vectors', 'Optimized Vectors']

# Prepare data for grouped bar chart
x = np.arange(len(array_sizes))  # Label locations
width = 0.25  # Width of bars

# Create bars for each method
bars1 = ax.bar(x - width, mean_times1, width, label=labels[0], 
               color=colors[0], edgecolor='black', linewidth=1.5, alpha=0.85)
bars2 = ax.bar(x, mean_times2, width, label=labels[1], 
               color=colors[1], edgecolor='black', linewidth=1.5, alpha=0.85)
bars3 = ax.bar(x + width, mean_times3, width, label=labels[2], 
               color=colors[2], edgecolor='black', linewidth=1.5, alpha=0.85)

# Add error bars
ax.errorbar(x - width, mean_times1, yerr=std_times1, fmt='none', 
            ecolor='black', capsize=4, capthick=1.5, alpha=0.7)
ax.errorbar(x, mean_times2, yerr=std_times2, fmt='none', 
            ecolor='black', capsize=4, capthick=1.5, alpha=0.7)
ax.errorbar(x + width, mean_times3, yerr=std_times3, fmt='none', 
            ecolor='black', capsize=4, capthick=1.5, alpha=0.7)

# Set logarithmic scale for y-axis only
ax.set_yscale('log')

# Labels and title with larger, bolder fonts
ax.set_xlabel('Array Size', fontsize=17, fontweight='bold', labelpad=10) 
ax.set_ylabel('Execution Time (ns)', fontsize=17, fontweight='bold', labelpad=10)
ax.set_title('Performance Comparison: Array Addition Methods', fontsize=19, fontweight='bold', pad=20)

# Enhanced grid
ax.grid(True, which="major", ls="-", alpha=0.4, linewidth=1.3, color='gray')
ax.grid(True, which="minor", ls=":", alpha=0.2, linewidth=0.8, color='gray')

# Better legend with frame
ax.legend(fontsize=13, loc='upper left', frameon=True, framealpha=0.98, shadow=False)

# Format the x-axis and y-axis labels with larger font
ax.set_xticks(x)
ax.set_xticklabels([f'10$^{int(np.log10(size))}$' for size in array_sizes_numeric], fontsize=15)
ax.tick_params(axis='y', labelsize=15)

# Add subtle background color
ax.set_facecolor('#F8F9FA')

# Add borders around the plot
for spine in ax.spines.values():
    spine.set_edgecolor('black')
    spine.set_linewidth(1.5)
    spine.set_visible(True)

# Tight layout
plt.tight_layout()
 
# Save the plot
plt.savefig('comparison_plot.png', dpi=300, bbox_inches='tight')
print("Comparison graph saved as 'comparison_plot.png'")

# Show the plot
plt.show()

# Print comparative statistics
print("\n" + "="*100)
print("PERFORMANCE COMPARISON: Array Addition Methods")
print("="*100)
print(f"\n{'Array Size':<15} {'Method 1 (ns)':<20} {'Method 2 (ns)':<20} {'Method 3 (ns)':<20}")
print(f"{'':15} {'Array Addition':<20} {'Vectors':<20} {'Optimized Vectors':<20}")
print("-"*100)

for i, size in enumerate(array_sizes):
    print(f"{size:<15} {mean_times1[i]:<20.0f} {mean_times2[i]:<20.0f} {mean_times3[i]:<20.0f}")

# Calculate speedup
print("\n" + "="*100)
print("SPEEDUP ANALYSIS (relative to Array Addition)")
print("="*100)
print(f"{'Array Size':<15} {'Vectors Speedup':<25} {'Optimized Vectors Speedup':<25}")
print("-"*100)

for i, size in enumerate(array_sizes):
    speedup2 = mean_times1[i] / mean_times2[i]
    speedup3 = mean_times1[i] / mean_times3[i]
    print(f"{size:<15} {speedup2:<25.2f}x {speedup3:<25.2f}x")

print("\n" + "="*100)
