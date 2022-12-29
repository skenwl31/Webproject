package utils;

public class BoardPageboots {
   /*
    List.jsp에서 전달해준 인수를 아래 매개변수를 통해 받는다. 
   */
   public static String pagingStr(int totalCount, int pageSize, int blockPage,
      int pageNum, String reqUrl) {
      
      //페이지 바로가기 링크를 저장할 문자열 변수 생성
      StringBuffer sb = new StringBuffer();
         
      int totalPages = (int)(Math.ceil(((double) totalCount / pageSize)));
      
      int pageTemp = (((pageNum -1) /  blockPage) * blockPage) + 1;
        sb.append("<ul class='pagination justify-content-center'>");
      
      //33.79x 34
      if(pageTemp != 1) {
         sb.append("<li class='page-item'><a href='" + reqUrl + "?pageNum=1' class='page-link'><i class=\"bi bi-skip-start-fill\"></i></i></a></li>");
         sb.append("<li class='page-item'><a href='" + reqUrl + "?pageNum=1' "+ " (pageTemp -1) " + " class='page-link'><i class=\"bi bi-skip-start-fill\"></i></a></li>");
      }
      
      int blockCount = 1;
      
      while ( blockCount <= blockPage && pageTemp <= totalPages) {
         
         if(pageTemp == pageNum) {
            sb.append("<li class='page-item'>");
            sb.append("<a href='" + reqUrl + "?pageNum="+pageNum+ "' class='page-link active'>"+pageNum+"</a>");
            sb.append("</li>");
            
            
         }else {
            sb.append("<li class='page-item'>");
            sb.append("<a href='" + reqUrl + "?pageNum="+pageTemp+ "' class='page-link'>"+pageTemp+"</a>");
            sb.append("</li>") ;
         }
         pageTemp++;
         blockCount++;
         
      }
      
      if(pageTemp <= totalPages) {
         sb.append("<li class='page-item'>");
         sb.append("<a href='" + reqUrl + "?pageNum="+ pageTemp +"'&nbsp; class='page-link'><i class='bi bi-skip-end-fill'></i></a>");
         sb.append("</li>");
         sb.append("<li class='page-item'>");
         sb.append("<a href='" + reqUrl + "?pageNum="+ totalPages + "'&nbsp; class='page-link style='width:33.79px height:34px;'><i class='bi bi-skip-forward-fill'></i></a>");
         sb.append("</li>");
      }
      sb.append("</ul>");
      return sb.toString();
   }
}