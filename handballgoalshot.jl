using GLMakie, ColorBrewer  #loading some packages

f=Figure(size = (750, 750))  #creating the Figure

a1=Axis(f[1,1],title="Shot scored") #first axis should represents where goal where scored
xlims!(a1,0.9,4.1)
ylims!(a1,-0.1,3.1)
a2=Axis(f[1,3],title="Total shot") #second axis represents where shot were taken
xlims!(a2,0.9,4.1)
ylims!(a2,-0.1,3.1)

linesegments!(a1,[1,1],[0,3],linewidth=10,color="red",linestyle=:dash) #making it looking like an handball goal
linesegments!(a1,[4,4],[0,3],linewidth=10,color="red",linestyle=:dash)
linesegments!(a1,[1,4],[3,3],linewidth=10,color="red",linestyle=:dash)
linesegments!(a2,[1,1],[0,3],linewidth=10,color="red",linestyle=:dash)
linesegments!(a2,[4,4],[0,3],linewidth=10,color="red",linestyle=:dash)
linesegments!(a2,[1,4],[3,3],linewidth=10,color="red",linestyle=:dash)


f[2, 1:4] = buttongrid = GridLayout(tellwidth = false) #creating two lines of buttons one for scored shot and one for missed shot
counts1=Observable([0,0,0,0,0,0,0,0,0]) #scored shot
counts2=Observable([0,0,0,0,0,0,0,0,0]) #missed shot
buttonlabels = ["Left Top","Left Mid","Left Bot","Mid Top"," Mid","Mid Bot","Right Top","Right Mid","Right Bot"] #separating the goal in 9 areas
buttons1 = buttongrid[1, 1:9] = [Button(f, label = "Scored : $l",buttoncolor="green3") for l in buttonlabels] #button for scored then for missed
buttons2 = buttongrid[2, 1:9] = [Button(f, label = "Missed $l",buttoncolor="red") for l in buttonlabels]

for i in 1:9 #clicking on button update the count
    on(buttons1[i].clicks) do n
        counts1[][i] += 1
        notify(counts1)
    end
end
for i in 1:9
    on(buttons2[i].clicks) do n
        counts2[][i] += 1
        notify(counts2)
    end
end

func1(x) = x*10 #this function is for making the markersize visible quickly
func2(x,y)=(x+y) #we add missed and scored goal to have the total shot taken
mul=lift(func1,counts1)
addi=lift(func2,counts1,counts2)
mul2=lift(func1,addi)

scat=scatter!(a1,[1.5,1.5,1.5,2.5,2.5,2.5,3.5,3.5,3.5],[2.5,1.5,0.5,2.5,1.5,0.5,2.5,1.5,0.5],colormap=:thermal,markersize=mul,color=counts1) #we are creating the plot
scat2=scatter!(a2,[1.5,1.5,1.5,2.5,2.5,2.5,3.5,3.5,3.5],[2.5,1.5,0.5,2.5,1.5,0.5,2.5,1.5,0.5],colormap=:thermal,markersize=mul2,color=addi)

Colorbar(f[1,2],scat) #making some colorbars to have the counts visible
Colorbar(f[1,4],scat2)



f
