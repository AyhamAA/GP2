using Application.Repositories.Interfaces;

using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        private readonly MedShareDbContext _dbContext;
        public GenericRepository(MedShareDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<T> GetById(int id)
        {
            return await _dbContext.Set<T>().FindAsync(id);
        }
        public IQueryable<T> GetAll()
        {
            return _dbContext.Set<T>();
        }

        public async Task Insert(T entity)
        {
            await _dbContext.Set<T>().AddAsync(entity);
        }

    

        public void Update(T entity)
        {
            _dbContext.Entry(entity).State = EntityState.Modified;
        }

        public async Task Delete(T entity)
        {
            _dbContext.Set<T>().Remove(entity);
        }

     
        public async Task<int> SaveChanges()
        {
            return await _dbContext.SaveChangesAsync();
        }
    }
}
