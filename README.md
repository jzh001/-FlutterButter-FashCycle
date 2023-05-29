# [FlutterButter] FashCycle

## Inspiration
Sustainable fashion has become a hot topic in recent years, with people becoming increasingly aware of the impact of their extensive wardrobes on the environment. However, many still struggle to comprehend the exact impact of our fast fashion habits on the environment, with studies finding a significant gap between consumers' awareness and their purchasing decisions. (source: httes://www.mdpi.com/1911-8074/14/12/594) As a result, consumers tend to make climate-unfriendly purchases that continue to fuel the carbon-intensive clothing industry that accounts for a staggering 10% of global carbon emissions. (source: https://www.unep.org/news-and-stories/press-release/un-alliance-sustainable-fashion-addresses-damage-fast-fashion)
However, reusing old clothing through second-lnd or even thirdhand sales can greatly increase the lifespan of a piece of garment and hence ameliorate the environmental burden that comes with the manufacture and transport of firsthand clothing. (source: https://euric.org/resource-hub/press-releases:
statements/press-release-clothing-reuse-has-0-20-times-lower-environmental-impact-reveals-new-study)
## What it does
Our application aims to set up a centralised online marketplace aimed towards potential buyers and sellers of used clothing, in hopes of giving used and unwanted clothing a second life while simultaneously preventing the sale of another piece of brand new clothing. What differentiates our implementation would be the carbon footprint calculator built into the app. It provides an estimate of the amount of carbon emissions that is prevented through the transfer of the secondhand clothing, as opposed to purchasing a brand new piece of the same clothing. Using real-world data regarding the type of clothing and the material used, we estimate the CO2 equivalent that is saved. We also estimate the amount of fabric saved in this process, and monitor these statistics over time. This gives consumers using the app a direct visualisation of the amount of carbon emissions saved, driving consumer satisfaction and improving consumer awareness regarding the environmental impact of fast fashion.
## How we built it
We built it using Flutter and Dart, and hosted all data and authentication on Google Firebase, a secure platform.
## Challenges we ran into
There were many issues integrating Flutter with Firebase, which held us back from generating new features. In addition, it was a challenge to conceptualize a model to calculate carbon footprint.

## What's next for [FlutterButter] FashCycle
We hope to incorporate elements of machine learning into our app, so that we can more accurately predict the carbon emissions saved based on a larger range of factors, such as the description of the products.

## Deployment Instructions
Download the APK file on this Github Repository, labelled app-release.apk.  

## Demo Video
Demo video available at https://youtu.be/Kjh8qCxWjKg

## Data Sources
Carbon emissions data of different types of fabric: https://hempfoundation.net/7-major-fibers-textiles-in-the-world-and-their-carbon-footprint/
Fabric data of different types of apparel: https://www.fabricsyard.com/print-by-the-yard-blog/how-much-fabric-do-you-need/
