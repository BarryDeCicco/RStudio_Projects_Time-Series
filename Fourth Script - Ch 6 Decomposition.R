
# Fourth Script - Ch 6 Decomposition

# Moving averages, on electricity sales in S. Africa:

autoplot(elecsales) + xlab("Year") + ylab("GWh") +
  ggtitle("Annual electricity sales: South Australia")


autoplot(elecsales, series="Data") +
  autolayer(ma(elecsales,2), series="2-MA") +
  autolayer(ma(elecsales,3), series="3-MA") +
  autolayer(ma(elecsales,5), series="5-MA") +
  xlab("Year") + ylab("GWh") +
  ggtitle("Annual electricity sales: South Australia") +
  scale_colour_manual(values=c("Data"="grey50",
               "2-MA"="blue", "3-MA"="green","5-MA"="red"),
                      breaks=c("Data","5-MA"))



# Electrical equipment manufacturing
# this has been normalized by working days/month,
# and adjusted so that the value for 2005 = 100.

autoplot(elecequip, series="Data")

# Classical decomposition (using pipes from magrittr)

elecequip %>% decompose(type="multiplicative") %>%
  autoplot() + xlab("Year") +
  ggtitle("Classical multiplicative decomposition
          of electrical equipment index")

# note the run of negative residuals for 2009 - you can
# see from the top plot that there was a sharp drop.

# This has some disadvantages:
# 
# The trend-cycle estimate tends to over-smooth rapid rises and falls in the data 
#
# Lack of robustness to short-term changes (e.g., strikes).
#
# It assumes that the seasonal component is unchanging
# over the life of the data.


# X11 Decomposition doesn't have those disadvantages
# it uses the 'seasonal' package.

elecequip %>% seas(x11="") -> fit
autoplot(fit) +
  ggtitle("X11 decomposition of electrical equipment index")


# STL Decomposition - “Seasonal and Trend decomposition using Loess”
#
# Advantage - 

# Unlike SEATS and X11, STL will handle any type of seasonality, 
#   not only monthly and quarterly data.
# The seasonal component is allowed to change over time, 
#   and the rate of change can be controlled by the user.
# 
# The smoothness of the trend-cycle can also be controlled by 
#   the user.
# It can be robust to outliers (i.e., the user can specify a 
#   robust decomposition), so that occasional unusual observations will not affect the estimates of the trend-cycle and seasonal components. They will, however, affect the remainder component.

# On the other hand, STL has some disadvantages. 
# In particular, it does not handle trading day or calendar 
# variation automatically, and it only provides facilities for 
# additive decompositions.

# you can get a multiplicative decomposition by taking logs.


elecequip %>%
  stl(t.window=13, s.window="periodic", robust=TRUE) %>%
  autoplot()

# Forecasting with decomposition

fit <- stl(elecequip, t.window=13, s.window="periodic",
           robust=TRUE)

View(fit)


autoplot(fit)


fit %>% seasadj() %>% naive() %>%
  autoplot() + ylab("New orders index") +
  ggtitle("Naive forecasts of seasonally adjusted data")


fit %>% forecast(method="naive") %>%
  autoplot() + ylab("New orders index")


# The prediction intervals shown in this graph are constructed 
# in the same way as the point forecasts. That is, 
# the upper and lower limits of the prediction intervals on the 
# seasonally adjusted data are “reseasonalized” by adding 
# in the forecasts of the seasonal component. 
# In this calculation, the uncertainty in the forecasts of the 
# seasonal component has been ignored. The rationale for this 
# choice is that the uncertainty in the seasonal component is 
# much smaller than that for the seasonally adjusted data, 
# and so it is a reasonable approximation to ignore it.

# A short-cut approach is to use the stlf() function. 
# The following code will decompose the time series using STL, 
# forecast the seasonally adjusted series, 
# and return reseasonalize the forecasts.

fcast <- stlf(elecequip, method='naive')
autoplot(fcast)


# The stlf() function uses mstl() to carry out the decomposition, 
# so there are default values for s.window and t.window.



