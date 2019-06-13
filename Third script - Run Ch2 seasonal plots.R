# Third script - Run Ch2 seasonal plots

View(a10)

# This plot creates a line plot by year, with months on the X-axis.

ggseasonplot(a10, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("$ million") +
  ggtitle("Seasonal plot: antidiabetic drug sales")

# Showing seasonality using polar coordinates:

ggseasonplot(a10, polar=TRUE) +
  ylab("$ million") +
  ggtitle("Polar seasonal plot: antidiabetic drug sales")

# This is a seasonal subseries plot - plotting each month's data
# separately (based on the 'tiny multples' idea)

ggsubseriesplot(a10) +
  ylab("$ million") +
  ggtitle("Seasonal subseries plot: antidiabetic drug sales")


