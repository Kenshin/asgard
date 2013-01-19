
/**
*
*/
exports.pagination_vo = function() {

	//分页的总数据
	this.total;
	//当前页
	this.page;
	//每页的内容数
	this.pagesize;
	//最后一页
	this.lastpage;
	//共计多少分页
	this.loopcount;
	//前一页
	this.previous;
	//后一页
	this.next;
	//是否显示前一页
	this.isprevious;
	//是否显示后一页
	this.isnext;
	//开始
	//例如：1 2 3 4 5 6，则指1；4 5 6 7 8 9，则指4
	this.begin;
	//结束
	this.end;
	//步长
	this.step;
	//是否可以前进，指">>"
	this.isforward;
	//是否可以后退，指"<<"
	this.isback;
	//前进到第几页
	this.forward;
	//后退到第几页
	this.back;
	//偏移量
	this.offset;
	//begin -> end 时的步长
	this.length;
}