﻿using AutoMapper;
using DineEaseApp.Dto;
using DineEaseApp.Interfaces;
using DineEaseApp.Models;
using Microsoft.AspNetCore.Mvc;

namespace DineEaseApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : Controller
    {
        private readonly IMapper _mapper;
        private readonly IUserRepository _userRepository;
        private readonly IConfiguration _configuration;
        private readonly IReviewRepository _reviewRepository;

        public ReviewController(IMapper mapper, IConfiguration configuration, IReviewRepository reviewRepository,IUserRepository userRepository)
        {
            _mapper = mapper;
            _configuration = configuration;
            _reviewRepository = reviewRepository;
            _userRepository = userRepository;
        }

        [HttpGet("user/{userId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Review>))]
        public async Task<IActionResult> GetReviewsByUserId(int userId)
        {
            var reviews = _mapper.Map<List<ReviewDto>>(await _reviewRepository.GetReviewsByUserId(userId));

            if(!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(reviews);
        }

        [HttpGet("restaurant/{restaurantId}")]
        [ProducesResponseType(200, Type = typeof(IEnumerable<Review>))]
        public async Task<IActionResult> GetReviewsByRestaurantId(int restaurantId)
        {
            var reviews = _mapper.Map<List<ReviewDto>>(await _reviewRepository.GetReviewsByRestaurantId(restaurantId));

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            return Ok(reviews);
        }

        [HttpPost("addReview")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> AddReview(ReviewCreateDto reviewCreateDto)
        {
            try
            {
                if(reviewCreateDto == null)
                {
                    return BadRequest(ModelState);
                }

                var reviewMap = _mapper.Map<Review>(reviewCreateDto);

                if(!await _reviewRepository.CreateReview(reviewMap))
                {
                    ModelState.AddModelError("", "Something went wrong while saving");
                    return StatusCode(500, ModelState);
                }

                return Ok("Successfully created");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

        [HttpPut("update/{reviewId}")]
        [ProducesResponseType(400)]
        [ProducesResponseType(204)]
        [ProducesResponseType(404)]
        public async Task<IActionResult> UpdateReview(int reviewId, [FromBody]ReviewDto reviewDto)
        {
            if(reviewDto == null)
            {
                return BadRequest(ModelState);
            }

            if(reviewDto.Id != reviewId)
            {
                return BadRequest(ModelState);
            }

            var r = await _reviewRepository.GetReviewById(reviewId);
            if (r == null)
            {
                return NotFound();
            }

            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if(r.UserId != reviewDto.UserId || r.RestaurantId != reviewDto.RestaurantId)
            {
                return BadRequest(ModelState);
            }


            var reviewMap = _mapper.Map<Review>(reviewDto);

            if(!await _reviewRepository.UpdateReview(reviewMap))
            {
                ModelState.AddModelError("", "Something went wrong while saving");
                return StatusCode(500, ModelState);
            }

            return NoContent();
        }

        [HttpDelete("deleteReview")]
        [ProducesResponseType(200)]
        public async Task<IActionResult> DeleteReview(int id)
        {
            try
            {
                var r = await _reviewRepository.GetReviewById(id);
                if(r == null)
                {
                    ModelState.AddModelError("", "Review nem letezik");
                    return BadRequest(ModelState);
                }

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                if(!await _reviewRepository.DeleteReview(r))
                {
                    ModelState.AddModelError("", "Something went wrong");
                    return BadRequest(ModelState);
                }
                return Ok("Successfully removed");
            }
            catch (Exception ex)
            {
                return (StatusCode(500, ex.Message));
            }
        }

    }
}
