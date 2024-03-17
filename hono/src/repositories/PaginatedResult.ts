import { SelectQueryBuilder } from "kysely";
import { Database } from "../types";
import { PaginationParams } from "../params/pagination";

export const paginatedResult = async (
    queryBase: SelectQueryBuilder<Database, any, any>,
    queryData: SelectQueryBuilder<Database, any, any>,
    pagination: PaginationParams
) => {
    const data = await queryData
        .limit(pagination.pageSize)
        .offset(pagination.pageSize * (pagination.pageNumber - 1))
        .execute()

    const { count } = await queryBase
        .select((eb) =>
            eb.fn.countAll().as('count')
        )
        .executeTakeFirstOrThrow()
    
    return { data, count: Number(count) }
}