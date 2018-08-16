clc;
clear;
close all;
x = FlowReader('SiouxFalls_flow.tntp');
y = TripsReader('SiouxFalls_trips.tntp',24);
z = NodeReader('SiouxFalls_node.tntp');