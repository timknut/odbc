// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include "odbconnect_types.h"
#include <Rcpp.h>

using namespace Rcpp;

// connect
connection_ptr connect(std::string connection_string);
RcppExport SEXP odbconnect_connect(SEXP connection_stringSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< std::string >::type connection_string(connection_stringSEXP);
    __result = Rcpp::wrap(connect(connection_string));
    return __result;
END_RCPP
}
// connect_info
std::string connect_info(connection_ptr p);
RcppExport SEXP odbconnect_connect_info(SEXP pSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< connection_ptr >::type p(pSEXP);
    __result = Rcpp::wrap(connect_info(p));
    return __result;
END_RCPP
}
// query
cursor_ptr query(connection_ptr p, std::string sql);
RcppExport SEXP odbconnect_query(SEXP pSEXP, SEXP sqlSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< connection_ptr >::type p(pSEXP);
    Rcpp::traits::input_parameter< std::string >::type sql(sqlSEXP);
    __result = Rcpp::wrap(query(p, sql));
    return __result;
END_RCPP
}
// fetch_row
Rcpp::RObject fetch_row(cursor_ptr c);
RcppExport SEXP odbconnect_fetch_row(SEXP cSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< cursor_ptr >::type c(cSEXP);
    __result = Rcpp::wrap(fetch_row(c));
    return __result;
END_RCPP
}
// statement_create
statement_ptr statement_create(connection_ptr con, std::string sql);
RcppExport SEXP odbconnect_statement_create(SEXP conSEXP, SEXP sqlSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< connection_ptr >::type con(conSEXP);
    Rcpp::traits::input_parameter< std::string >::type sql(sqlSEXP);
    __result = Rcpp::wrap(statement_create(con, sql));
    return __result;
END_RCPP
}
// row_count
int row_count(statement_ptr rs);
RcppExport SEXP odbconnect_row_count(SEXP rsSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< statement_ptr >::type rs(rsSEXP);
    __result = Rcpp::wrap(row_count(rs));
    return __result;
END_RCPP
}
