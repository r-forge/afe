species<- c("a","b","c","c","b","c","b","b","a","b","c","c","a","a","b","b","a","a","b","c")
habitat<-  c("x","x","x","y","y","y","x","x","y","z","y","y","z","z","x","x","y","y","z","z")
mvt.rate<-c(6,5,7,8,9,4,3,5,6,9,3,6,6,7,8,9,5,6,7,8)
ind<-as.factor(c(1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4))
data1<-data.frame(species, habitat, mvt.rate, ind)

str(data1)

xtabs(~ species + habitat + ind)

# should give an error
ez.glm("ind", "mvt.rate", data1, within = "habitat", between = "species")
