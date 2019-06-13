# Fifth Script - Ch 8 - ARIMA

cbind("Sales ($million)" = a10,
      "Monthly log sales" = log(a10),
      "Annual change in log sales" = diff(log(a10),12)) %>%
  autoplot(facets=TRUE) +
  xlab("Year") + ylab("") +
  ggtitle("Antidiabetic drug sales")

# Sometimes it is necessary to take both a 
# seasonal difference and a first difference to 
# obtain stationary data, as is shown in Figure 8.4. 
# Here, the data are first transformed using logarithms 
# (second panel), then seasonal differences are 
# calculated (third panel).
# 
# The data still seem somewhat non-stationary, 
# and so a further lot of first differences are 
# computed (bottom panel).

cbind("Billion kWh" = usmelec,
      "Logs" = log(usmelec),
      "Seasonally\n differenced logs" =
        diff(log(usmelec),12),
      "Doubly\n differenced logs" =
        diff(diff(log(usmelec),12),1)) %>%
  autoplot(facets=TRUE) +
  xlab("Year") + ylab("") +
  ggtitle("Monthly US net electricity generation")


#  Unit root tests

# One way to determine more objectively whether 
# differencing is required is to use a unit root test. 
# These are statistical hypothesis tests of stationarity 
# that are designed for determining whether 
# differencing is required.

# Applying the Kwiatkowski-Phillips-Schmidt-Shin 
# (KPSS) test from the urca package to the
# Google stock price data set:


library(urca)
goog %>% ur.kpss() %>% summary()

# this is a highly significant value, suggesting that
# the data should be differenced - do that, and repeat:

goog %>% diff() %>% ur.kpss() %>% summary()

# To do this iteratively, use ndiffs();
# for seasonal differencing, us nsdiffs().

?ndiffs()

?nsdiffs()

nsdiffs(goog, test = "seas")

# nsdiffs will throw an error if it thinks that the
# data is non seasonal.

# Try this on the (logged) US electricity data:

usmelec %>% log() %>% nsdiffs()

usmelec %>% log() %>% diff(lag=12) %>% ndiffs()


usmelec %>% log() %>% findfrequency()

logged_usmelec <- usmelec %>% log()


ggseasonplot(logged_usmelec, year.labels=TRUE, year.labels.left=TRUE) +
  ylab("Logged Consumption") +
  ggtitle("Seasonal plot: Logged UM Monthly Electical Consumption")



# Showing seasonality using polar coordinates:

ggseasonplot(logged_usmelec, polar=TRUE) +
  ylab("Logged Consumption") +
  ggtitle("Polar seasonal plot: Logged UM Monthly Electical Consumption")

ets(logged_usmelec)


x <- ts(logged_usmelec, frequency=365/12)
fit <- tbats(x)
seasonal <- !is.null(fit$seasonal)

vignette("seas")
