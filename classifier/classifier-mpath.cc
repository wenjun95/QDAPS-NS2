/* -*-	Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */

/*
 * Copyright (C) 1997 by the University of Southern California
 * $Id: classifier-mpath.cc,v 1.10 2005/08/25 18:58:01 johnh Exp $
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 *
 * The copyright of this module includes the following
 * linking-with-specific-other-licenses addition:
 *
 * In addition, as a special exception, the copyright holders of
 * this module give you permission to combine (via static or
 * dynamic linking) this module with free software programs or
 * libraries that are released under the GNU LGPL and with code
 * included in the standard release of ns-2 under the Apache 2.0
 * license or under otherwise-compatible licenses with advertising
 * requirements (or modified versions of such code, with unchanged
 * license).  You may copy and distribute such a system following the
 * terms of the GNU GPL for this module and the licenses of the
 * other code concerned, provided that you include the source code of
 * that other code when and as the GNU GPL requires distribution of
 * source code.
 *
 * Note that people who make modified versions of this module
 * are not obligated to grant this special exception for their
 * modified versions; it is their choice whether to do so.  The GNU
 * General Public License gives permission to release a modified
 * version without this exception; this exception also makes it
 * possible to release a modified version which carries forward this
 * exception.
 *
 */

#ifndef lint
static const char rcsid[] =
    "@(#) $Header: /cvsroot/nsnam/ns-2/classifier/classifier-mpath.cc,v 1.10 2005/08/25 18:58:01 johnh Exp $ (USC/ISI)";
#endif

#include "classifier.h"
#include<stdio.h> 
#include<sys/time.h>
#include<time.h>
#include "random.h" 
#include "/home/wenjun/音乐/ns-allinone-2.35/ns-2.35/common/ip.h"
#include "/home/wenjun/音乐/ns-allinone-2.35/ns-2.35/queue/queue.h"
#include "/home/wenjun/音乐/ns-allinone-2.35/ns-2.35/common/packet.h"
//int a[7]={1,2,3,4,5,6,7};
int pnum=4;
int pid[100]={0};
int clflag[100]={0};
double start[100]={0},end[100]={0};
int min[100]={0};
int locate[100]={1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1,
				1,1,1,1,1,1,1,1,1,1};
int nowlocate[100]={0};
//extern int changepathflag;


int b[2]={0,0};
int *selectmin(int a[],int c){       //a[] is the length of queue,c is the number of paths,select the first smallest
	
	
	b[0]=a[1];
	for(int i=2;i<=c;i++){
		if(a[i]<b[0]) {
		b[0]=a[i];
	}}
	for(int j=1;j<=c;j++){
		if(a[j]==b[0]){
		b[1]=j;
		break;
	}}
	return b;
}
int d[2]={0,0};
int *selectsuitable(int a[],int b,int c,int flag){   //b is the locate now of last packet,c is the total number of paths,flag is the last path selected
	
	int m=a[flag];
	for(int i=1;i<=c;i++){
		if(a[i]>=b&&a[i]<m){
				m=a[i];}
	}
	d[0]=m;
	/*for(int k=1;k<=c;k++){
	    if(a[k]==0){
		d[0]=a[k];}
	}*/
	for(int j=1;j<=c;j++){
		if(a[j]==d[0]){
			d[1]=j;
			//break;
		}}
/*	    int x=a[1];
		for(int i=2;i<=c;i++){
		if(a[i]<x) {
		x=a[i];
	}}*/
	if(d[0]>41){
	     //int i=(int)Random::uniform(1,c+1);
		// int j=(int)Random::uniform(1,c+1);
		 //if(a[i]<d[0]){d[0]=a[i];d[1]=i;}
		 //if(a[j]<d[0]){d[0]=a[j];d[1]=j;}
            	d[0]=a[1];
	for(int i=2;i<=c;i++){
		if(a[i]<d[0]) {
		d[0]=a[i];
	}}
	for(int j=1;j<=c;j++){
		if(a[j]==d[0]){
		d[1]=j;
		break;
	}}
	 }
	return d;
}


class MultiPathForwarder : public Classifier {
public:
	MultiPathForwarder() : ns_(0) {} 
	virtual int classify(Packet* p) {
		int cl=0;
		int fail = ns_; 

		hdr_ip* iph=hdr_ip::access(p);
        int fid = iph->flowid();
		int databytes=hdr_cmn::access(p)->size();
		if(pid[fid]==0){
				start[fid]=Scheduler::instance().clock();
			    min[fid]=selectmin(qlenAr,pnum)[0];
				locate[fid]=selectmin(qlenAr,pnum)[1];
			    pid[fid]++;
			    clflag[fid]=locate[fid];
			    cl=locate[fid]-1; 

		 }
		else if(databytes==1500) {
            end[fid]=Scheduler::instance().clock();
			double temp=end[fid]-start[fid];
			int pktnum=temp/0.000012;
			nowlocate[fid]=min[fid]+1-pktnum;
			if(nowlocate[fid]<0){nowlocate[fid]=0;}
			min[fid]=selectsuitable(qlenAr,nowlocate[fid],pnum,clflag[fid])[0];  //length
			locate[fid]=selectsuitable(qlenAr,nowlocate[fid],pnum,clflag[fid])[1];  //number
			cl=locate[fid]-1;
			
			clflag[fid]=locate[fid];
			start[fid]=end[fid];
                 }	
		    
		else{
		do{cl = ns_++; 
		ns_ %= (maxslot_ + 1);
		  
		  }while (slot_[cl] == 0 && ns_ != fail);
		}
		
		return cl;	
               
		
	}
private:
	int ns_;
};

static class MultiPathClass : public TclClass {
public:
	MultiPathClass() : TclClass("Classifier/MultiPath") {} 
	TclObject* create(int, const char*const*) {
		return (new MultiPathForwarder());
	}
} class_multipath;
