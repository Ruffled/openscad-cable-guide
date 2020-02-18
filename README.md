# openscad-cable-guide
This is a cable guide developed in OpenSCAD. It is a parametric model. It is a work in progress.

One of the things I have found, and I am trying to address it, is that printing in PLA is very fragile when you flex parts across layers. I am working to mitigate this. If you orient the guide vertically in your slicer, the tangs of the guide will be more durable since you are not flexing them across the layers. I am looking at thinning the walls by extending the sidewall the relief the full height of the slot on each side. If you print in ABS this issue is less of a problem, but I would like to enable PLA based guides.

The design is intended to be self explanatory.
It opens with a module that generates a single cable slot cell, with paramatized dimensions.

That is followed by a set of parameters to define a cell that is a 50mm cube (about two inches).
That is followed by a generator loop that currently defaults to 5 cells.

I intend to carry this forward with additional features, but here is the start, and your are welcome to it.

Licensed under creative commons.

Feel free to clone, and if you would like to fancy it up, and issue a PR request, I'll certainly consider submissions.

I am just learning OpenSCAD, so I will also accept any constructive criticism.

I recently added two features that were sorely needed. A linear wall relief near the base of each slot to make it easier to flex the tangs when you are inserting a cable, and mounting holes located at each tang.

In the latest update, I am now generating a very rudimentary cover.
