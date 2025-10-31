import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read the CSV file
df = pd.read_csv('data_met1_cleaned.csv')

# Extract the column names (array sizes)
array_sizes = df.columns.tolist()
# Convert array sizes to actual numbers (e.g., "10^2" to 100)
array_sizes_numeric = [eval(size.replace('^', '**')) for size in array_sizes]

# Calculate statistics for each array size
mean_times = df.mean()
min_times = df.min()
max_times = df.max()
std_times = df.std()

# Set style for better aesthetics
plt.style.use('seaborn-v0_8-darkgrid')

# Create the plot with increased width
fig, ax = plt.subplots(figsize=(9, 6))

# Define eye-friendly colors
mean_color = "#AB2E2E"  # Professional blue
fill_color = "#08309D"  # Warm orange

# Fill the area between min and max with better visibility
ax.fill_between(array_sizes_numeric, min_times, max_times, 
                alpha=0.25, color=fill_color, label='Min-Max Range', zorder=1)

# Plot mean with error bars (std deviation)
ax.errorbar(array_sizes_numeric, mean_times, yerr=std_times, 
            fmt='o-', linewidth=3, markersize=12, capsize=8, 
            label='Mean ± Std Dev', color=mean_color, 
            elinewidth=2, capthick=2.5, markeredgecolor='white', 
            markeredgewidth=1.5, zorder=3)

# Set logarithmic scales
ax.set_xscale('log')
ax.set_yscale('log')

# Labels and title with larger, bolder fonts
ax.set_xlabel('Array Size', fontsize=17, fontweight='normal', labelpad=10) 
ax.set_ylabel('Execution Time (ns)', fontsize=17, fontweight='normal', labelpad=10, va = 'bottom')
# Place the title below the axes (bottom-center). y is relative to the axes: negative moves it below.
ax.set_title('Execution Time vs Array Size', fontsize=19, fontweight='bold', y=-0.22)

# Enhanced grid
ax.grid(True, which="major", ls="-", alpha=0.4, linewidth=1.3, color='gray')
ax.grid(True, which="minor", ls=":", alpha=0.2, linewidth=0.8, color='gray')

# Better legend with frame
ax.legend(fontsize=13, loc='upper left', frameon=True, framealpha=0.98, shadow=False)

# Format the x-axis and y-axis labels with larger font
ax.set_xticks(array_sizes_numeric)
ax.set_xticklabels([f'10$^{int(np.log10(x))}$' for x in array_sizes_numeric], fontsize=15)
ax.tick_params(axis='y', labelsize=15)

# Add subtle background color
ax.set_facecolor('#F8F9FA')

# Add borders around the plot
for spine in ax.spines.values():
    spine.set_edgecolor('black')
    spine.set_linewidth(1.0)    
    spine.set_visible(True)

# Reserve space at the bottom so the title placed below the axes is visible
fig.subplots_adjust(bottom=0.23)
plt.tight_layout()
 
# Print mean values for each array size
print("\n=== Mean Execution Time by Array Size ===")
for i, size in enumerate(array_sizes):
    print(f"Array Size {size}: {mean_times.iloc[i]:.0f} ns")

# Print detailed statistics
print("\n=== Detailed Execution Time Statistics (ns) ===")
print(f"{'Array Size':<15} {'Mean':<15} {'Std Dev':<15} {'Min':<15} {'Max':<15}")
print("=" * 75)
for i, size in enumerate(array_sizes):
    print(f"{size:<15} {mean_times.iloc[i]:<15.0f} "
          f"{std_times.iloc[i]:<15.0f} {min_times.iloc[i]:<15.0f} {max_times.iloc[i]:<15.0f}")

# Save the plot
plt.savefig('execution_time_plot.png', dpi=300, bbox_inches='tight')

# Show the plot
plt.show()
